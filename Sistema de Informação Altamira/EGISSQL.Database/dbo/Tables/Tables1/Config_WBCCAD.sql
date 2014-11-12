CREATE TABLE [dbo].[Config_WBCCAD] (
    [cd_empresa] INT           NOT NULL,
    [nm_caminho] VARCHAR (150) NULL,
    [nm_banco_1] VARCHAR (80)  NULL,
    [nm_banco_2] VARCHAR (80)  NULL,
    [nm_banco_3] VARCHAR (80)  NULL,
    [cd_usuario] INT           NULL,
    [dt_usuario] DATETIME      NULL,
    CONSTRAINT [PK_Config_WBCCAD] PRIMARY KEY CLUSTERED ([cd_empresa] ASC)
);

