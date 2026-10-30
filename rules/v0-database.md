# Database schema before 1.0

While the project's version is below 1.0, nothing runs anywhere that would have to be migrated.

- **Below 1.0, there are no migrations.** Change the schema where it is defined. Create no migration
  and no directory for them; where migrations exist already, change them along with the schema
  instead of adding one.
- **The last step before 1.0 creates the one migration.** Generate a single first migration from
  the final schema, where the project's migration tool expects it; it replaces any migrations from
  before. Have the schema signed off before the release.
