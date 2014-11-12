CREATE TABLE [dbo].[Modulo_Data_Module] (
    [cd_modulo]      INT      NOT NULL,
    [cd_data_module] INT      NOT NULL,
    [cd_usuario]     INT      NULL,
    [dt_usuario]     DATETIME NULL,
    CONSTRAINT [PK_Modulo_Data_Module] PRIMARY KEY CLUSTERED ([cd_modulo] ASC, [cd_data_module] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Modulo_Data_Module_Data_Module] FOREIGN KEY ([cd_data_module]) REFERENCES [dbo].[Data_Module] ([cd_data_module])
);

