CREATE TABLE [dbo].[Data_Module_Componente] (
    [cd_data_module]         INT          NOT NULL,
    [cd_tipo_componente]     INT          NOT NULL,
    [nm_componente_data]     VARCHAR (30) NOT NULL,
    [ds_componente_data]     TEXT         NULL,
    [nm_obs_componente_data] VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Data_Module_Componente] PRIMARY KEY CLUSTERED ([cd_data_module] ASC, [cd_tipo_componente] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Data_Module_Componente_Tipo_Componente_Sistema] FOREIGN KEY ([cd_tipo_componente]) REFERENCES [dbo].[Tipo_Componente_Sistema] ([cd_tipo_componente])
);

