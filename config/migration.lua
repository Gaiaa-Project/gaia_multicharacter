MigrationConfig = {
    --- Enable or disable the auto-migration system.
    ---
    --- • true (default): Automatically check and apply database migrations
    --- • false: Disable auto-migration completely
    enabled = true,

    --- Enable detection of missing columns even if the version hasn't changed.
    ---
    --- • true (default): Auto-repair if someone manually deleted a column
    --- • false: Only check on version change
    detectMissing = true,

    schema = {
        --- Schema version — bump this when you modify the schema.
        version = '0.0.1',

        --- Columns to add to the existing `characters` table managed by gaia_core.
        --- The migration system will detect missing columns and add them.
        tables = {
            {
                name = 'characters',
                columns = {
                    { name = 'firstname', type = 'VARCHAR(50)', default = 'NULL' },
                    { name = 'lastname', type = 'VARCHAR(50)', default = 'NULL' },
                    { name = 'date_of_birth', type = 'DATE', default = 'NULL' },
                    { name = 'sex', type = 'VARCHAR(10)', default = 'NULL' },
                    { name = 'nationality', type = 'VARCHAR(50)', default = 'NULL' },
                    { name = 'height', type = 'SMALLINT', unsigned = true, default = 'NULL' },
                    { name = 'appearance', type = 'JSON', default = 'NULL' },
                },
            },
        },
    },
}
