CREATE TABLE [dbo].[Data_Module] (
    [cd_data_module]           INT           NOT NULL,
    [nm_data_module]           VARCHAR (40)  NULL,
    [nm_fantasia_data_module]  VARCHAR (20)  NOT NULL,
    [ic_ativo_data_module]     CHAR (1)      NULL,
    [nm_documento_data_module] VARCHAR (100) NULL,
    [nm_obs_data_module]       VARCHAR (40)  NULL,
    [cd_usuario]               INT           NULL,
    [dt_usuario]               DATETIME      NULL,
    CONSTRAINT [PK_Data_Module] PRIMARY KEY CLUSTERED ([cd_data_module] ASC) WITH (FILLFACTOR = 90)
);

