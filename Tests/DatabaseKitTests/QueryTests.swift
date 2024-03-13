import DatabaseMigrationKit
import DatabaseQueryKit
import FeatherComponent
import FeatherRelationalDatabase
import XCTest

extension Todo.Model {

    static func mock(_ i: Int = 1) -> Todo.Model {
        Todo.Model(
            id: .init(rawValue: "id-\(i)"),
            title: "title-\(i)",
            notes: "notes-\(i)"
        )
    }
}

final class QueryTests: TestCase {

    func testInsert() async throws {

        try await components.runMigrationGroups([
            Todo.MigrationGroup()
        ])

        let todo = Todo.Model.mock()
        let rdbc = try await components.relationalDatabase()
        let db = try await rdbc.database()
        let todoQueryBuilder = Todo.QueryBuilder(db: db)

        try await todoQueryBuilder.insert(todo)
    }

    func testCount() async throws {

        try await components.runMigrationGroups([
            Todo.MigrationGroup()
        ])
        
        let rdbc = try await components.relationalDatabase()
        let db = try await rdbc.database()
        let todoQueryBuilder = Todo.QueryBuilder(db: db)
        
        let models: [Todo.Model] = (1...50)
            .map {
                .mock($0)
            }
        try await todoQueryBuilder.insert(models)


        let count1 = try await todoQueryBuilder.count()
        XCTAssertEqual(count1, 50)
        
        let count2 = try await todoQueryBuilder.count(
            filter: .init(
                field: .title,
                operator: .like,
                value: ["title-1%"]
            )
        )
        XCTAssertEqual(count2, 11)
    }
    

    func testGet() async throws {

        try await components.runMigrationGroups([
            Todo.MigrationGroup()
        ])

        let todo = Todo.Model.mock()
        let rdbc = try await components.relationalDatabase()
        let db = try await rdbc.database()
        let todoQueryBuilder = Todo.QueryBuilder(db: db)
        try await todoQueryBuilder.insert(todo)

        let todo1 = try await todoQueryBuilder.get("id-1")

        XCTAssertEqual(todo1?.id.rawValue, "id-1")

    }

    func testFirst() async throws {

        try await components.runMigrationGroups([
            Todo.MigrationGroup()
        ])

        let rdbc = try await components.relationalDatabase()
        let db = try await rdbc.database()
        let todoQueryBuilder = Todo.QueryBuilder(db: db)

        let todo1 = Todo.Model.mock(1)
        try await todoQueryBuilder.insert(todo1)
        let todo2 = Todo.Model.mock(2)
        try await todoQueryBuilder.insert(todo2)

        let res1 = try await todoQueryBuilder.first(
            filter: .init(
                field: .id,
                operator: .in,
                value: ["id-1", "id-2"]
            ),
            order: .init(
                field: .title,
                direction: .desc
            )
        )

        XCTAssertEqual(todo2.id, res1?.id)

        let res2 = try await todoQueryBuilder.first(
            filter: .init(
                field: .id,
                operator: .equal,
                value: ["id-2"]
            )
        )

        XCTAssertEqual(todo2.id, res2?.id)
    }

    func testUpdate() async throws {

        try await components.runMigrationGroups([
            Todo.MigrationGroup()
        ])

        let todo = Todo.Model.mock()
        let rdbc = try await components.relationalDatabase()
        let db = try await rdbc.database()
        let todoQueryBuilder = Todo.QueryBuilder(db: db)
        try await todoQueryBuilder.insert(todo)

        try await todoQueryBuilder.update("id-1", .mock(2))

        let todo1 = try await todoQueryBuilder.get("id-2")
        XCTAssertEqual(todo1?.id.rawValue, "id-2")
        XCTAssertEqual(todo1?.title, "title-2")
        XCTAssertEqual(todo1?.notes, "notes-2")
    }

    func testDelete() async throws {
        try await components.runMigrationGroups([
            Todo.MigrationGroup()
        ])

        let rdbc = try await components.relationalDatabase()
        let db = try await rdbc.database()
        let todoQueryBuilder = Todo.QueryBuilder(db: db)

        let models: [Todo.Model] = (1...6)
            .map {
                .mock($0)
            }
        try await todoQueryBuilder.insert(models)

        let total = try await todoQueryBuilder.count()
        XCTAssertEqual(total, 6)

        print(try await todoQueryBuilder.all())

        try await todoQueryBuilder.delete(Key<Todo>("id-1"))

        try await todoQueryBuilder.delete(
            filter: .init(
                field: .id,
                operator: .in,
                value: [
                    Key<Todo>("id-2"),
                    Key<Todo>("id-3"),
                ]
            )
        )

        try await todoQueryBuilder.delete(
            filter: .init(
                field: .title,
                operator: .in,
                value: [
                    "title-4",
                    "title-5",
                ]
            )
        )

        let all = try await todoQueryBuilder.all()
        XCTAssertEqual(all.count, 1)
        XCTAssertEqual(all[0].id.rawValue, "id-6")
    }

    func testAll() async throws {

        try await components.runMigrationGroups([
            Todo.MigrationGroup()
        ])

        let rdbc = try await components.relationalDatabase()
        let db = try await rdbc.database()
        let todoQueryBuilder = Todo.QueryBuilder(db: db)

        let models: [Todo.Model] = (1...50)
            .map {
                .mock($0)
            }
        try await todoQueryBuilder.insert(models)

        let res1 = try await todoQueryBuilder.all()
        XCTAssertEqual(res1.count, 50)

        let res2 = try await todoQueryBuilder.all(
            filter: .init(
                field: .title,
                operator: .in,
                value: ["title-1", "title-2"]
            )
        )
        XCTAssertEqual(res2.count, 2)

        let res3 = try await todoQueryBuilder.all(
            filter: .init(
                field: .title,
                operator: .equal,
                value: "title-2"
            )
        )
        XCTAssertEqual(res3.count, 1)
    }

    func testListFilterGroupUsingOrRelation() async throws {

        try await components.runMigrationGroups([
            Todo.MigrationGroup()
        ])

        let rdbc = try await components.relationalDatabase()
        let db = try await rdbc.database()
        let todoQueryBuilder = Todo.QueryBuilder(db: db)

        let models: [Todo.Model] = (1...50)
            .map {
                .mock($0)
            }
        try await todoQueryBuilder.insert(models)

        let list1 = try await todoQueryBuilder.list(
            .init(
                page: .init(
                    size: 5,
                    index: 0
                ),
                orders: [
                    .init(
                        field: .title,
                        direction: .asc
                    )
                ],
                filterGroup: .init(
                    relation: .or,
                    filters: [
                        .init(
                            field: .title,
                            operator: .in,
                            value: ["title-1", "title-2"]
                        ),
                        .init(
                            field: .notes,
                            operator: .equal,
                            value: "notes-3"
                        ),
                    ]
                )
            )
        )

        XCTAssertEqual(list1.total, 3)
        XCTAssertEqual(list1.items.count, 3)
        XCTAssertEqual(list1.items[0].title, "title-1")
        XCTAssertEqual(list1.items[1].title, "title-2")
        XCTAssertEqual(list1.items[2].title, "title-3")
    }

    func testListOrder() async throws {

        try await components.runMigrationGroups([
            Todo.MigrationGroup()
        ])

        let rdbc = try await components.relationalDatabase()
        let db = try await rdbc.database()
        let todoQueryBuilder = Todo.QueryBuilder(db: db)

        try await todoQueryBuilder.insert(
            [
                .init(
                    id: .init(
                        rawValue: "id-1"
                    ),
                    title: "title-1",
                    notes: "notes-1"
                ),
                .init(
                    id: .init(
                        rawValue: "id-2"
                    ),
                    title: "title-1",
                    notes: "notes-2"
                ),
                .init(
                    id: .init(
                        rawValue: "id-3"
                    ),
                    title: "title-2",
                    notes: "notes-1"
                ),
                .init(
                    id: .init(
                        rawValue: "id-4"
                    ),
                    title: "title-2",
                    notes: "notes-2"
                ),
            ]
        )

        let list1 = try await todoQueryBuilder.list(
            .init(
                page: .init(
                    size: 5,
                    index: 0
                ),
                orders: [
                    .init(
                        field: .title,
                        direction: .desc
                    ),
                    .init(
                        field: .notes,
                        direction: .asc
                    ),
                ]
            )
        )

        XCTAssertEqual(list1.total, 4)
        XCTAssertEqual(list1.items.count, 4)

        XCTAssertEqual(list1.items[0].title, "title-2")
        XCTAssertEqual(list1.items[0].notes, "notes-1")

        XCTAssertEqual(list1.items[1].title, "title-2")
        XCTAssertEqual(list1.items[1].notes, "notes-2")

        XCTAssertEqual(list1.items[2].title, "title-1")
        XCTAssertEqual(list1.items[2].notes, "notes-1")

        XCTAssertEqual(list1.items[3].title, "title-1")
        XCTAssertEqual(list1.items[3].notes, "notes-2")

    }

    func testList() async throws {

        try await components.runMigrationGroups([
            Todo.MigrationGroup()
        ])

        let rdbc = try await components.relationalDatabase()
        let db = try await rdbc.database()
        let todoQueryBuilder = Todo.QueryBuilder(db: db)

        let models: [Todo.Model] = (1...50)
            .map {
                .mock($0)
            }
        try await todoQueryBuilder.insert(models)

        let list1 = try await todoQueryBuilder.list(
            .init(
                page: .init(
                    size: 5,
                    index: 0
                ),
                orders: [
                    .init(
                        field: .title,
                        direction: .desc
                    )
                ],
                filterGroup: .init(
                    relation: .and,
                    filters: [
                        .init(
                            field: .title,
                            operator: .like,
                            value: "%title-1%"
                        ),
                        .init(
                            field: .notes,
                            operator: .like,
                            value: "%notes-1%"
                        ),
                    ]
                )
            )
        )

        XCTAssertEqual(list1.total, 11)
        XCTAssertEqual(list1.items.count, 5)
        XCTAssertEqual(list1.items[0].title, "title-19")
        XCTAssertEqual(list1.items[1].title, "title-18")
        XCTAssertEqual(list1.items[2].title, "title-17")
        XCTAssertEqual(list1.items[3].title, "title-16")
        XCTAssertEqual(list1.items[4].title, "title-15")

        let list2 = try await todoQueryBuilder.list(
            .init(
                page: .init(
                    size: 5,
                    index: 1
                ),
                orders: [
                    .init(
                        field: .title,
                        direction: .desc
                    )
                ],
                filterGroup: .init(
                    relation: .and,
                    filters: [
                        .init(
                            field: .title,
                            operator: .like,
                            value: "%title-1%"
                        ),
                        .init(
                            field: .notes,
                            operator: .like,
                            value: "%notes-1%"
                        ),
                    ]
                )
            )
        )

        XCTAssertEqual(list2.total, 11)
        XCTAssertEqual(list2.items.count, 5)
        XCTAssertEqual(list2.items[0].title, "title-14")
        XCTAssertEqual(list2.items[1].title, "title-13")
        XCTAssertEqual(list2.items[2].title, "title-12")
        XCTAssertEqual(list2.items[3].title, "title-11")
        XCTAssertEqual(list2.items[4].title, "title-10")

        let list3 = try await todoQueryBuilder.list(
            .init(
                page: .init(
                    size: 5,
                    index: 2
                ),
                orders: [
                    .init(
                        field: .title,
                        direction: .desc
                    )
                ],
                filterGroup: .init(
                    relation: .and,
                    filters: [
                        .init(
                            field: .title,
                            operator: .like,
                            value: "%title-1%"
                        ),
                        .init(
                            field: .notes,
                            operator: .like,
                            value: "%notes-1%"
                        ),
                    ]
                )
            )
        )

        XCTAssertEqual(list3.total, 11)
        XCTAssertEqual(list3.items.count, 1)
        XCTAssertEqual(list3.items[0].title, "title-1")
    }
}
