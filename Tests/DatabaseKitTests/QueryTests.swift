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

        let todo = Todo.Model.mock()
        let rdbc = try await components.relationalDatabase()
        let db = try await rdbc.database()
        let todoQueryBuilder = Todo.QueryBuilder(db: db)
        try await todoQueryBuilder.insert(todo)

        let count = try await todoQueryBuilder.count()
        XCTAssertEqual(count, 1)
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
        let todo2 = try await todoQueryBuilder.first(.title, .equal, "title-1")

        XCTAssertEqual(todo1?.id.rawValue, "id-1")
        XCTAssertEqual(todo2?.id.rawValue, "id-1")
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

        try await todoQueryBuilder.delete([
            Key<Todo>("id-2"),
            Key<Todo>("id-3"),
        ])

        try await todoQueryBuilder.delete(
            .title,
            .in,
            [
                "title-4",
                "title-5",
            ]
        )

        let all = try await todoQueryBuilder.all()
        XCTAssertEqual(all.count, 1)
        XCTAssertEqual(all[0].id.rawValue, "id-6")
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

        let total = try await todoQueryBuilder.count()
        XCTAssertEqual(total, 50)

        let list1 = try await todoQueryBuilder.list(
            .init(
                page: .init(size: 5, index: 0),
                sort: .init(field: .title, direction: .desc),
                search: .init(
                    field: .title,
                    method: .like,
                    value: "title-1%"
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
                page: .init(size: 5, index: 1),
                sort: .init(field: .title, direction: .desc),
                search: .init(
                    field: .title,
                    method: .like,
                    value: "title-1%"
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
                page: .init(size: 5, index: 2),
                sort: .init(field: .title, direction: .desc),
                search: .init(
                    field: .title,
                    method: .like,
                    value: "title-1%"
                )
            )
        )

        XCTAssertEqual(list3.total, 11)
        XCTAssertEqual(list3.items.count, 1)
        XCTAssertEqual(list3.items[0].title, "title-1")
    }
}
