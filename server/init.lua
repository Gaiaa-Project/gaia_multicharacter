MySQL.ready(function()
    Gaia.migration.run(MigrationConfig)
    Gaia.print.success('Multicharacter initialization complete')
end)
