MySQL.ready(function()
    while not GlobalState['gaia_core:state:schemaReady'] do
        Wait(50)
    end

    Gaia.migration.run(MigrationConfig)
    Gaia.print.success('Multicharacter initialization complete')
end)
