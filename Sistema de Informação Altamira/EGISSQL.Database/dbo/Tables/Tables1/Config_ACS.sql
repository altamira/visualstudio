CREATE TABLE [dbo].[Config_ACS] (
    [cd_empresa]         INT        NOT NULL,
    [qt_dia_faturamento] FLOAT (53) NULL,
    [cd_usuario]         INT        NULL,
    [dt_usuario]         DATETIME   NULL,
    CONSTRAINT [PK_Config_ACS] PRIMARY KEY CLUSTERED ([cd_empresa] ASC),
    CONSTRAINT [FK_Config_ACS_Empresa] FOREIGN KEY ([cd_empresa]) REFERENCES [dbo].[Empresa] ([cd_empresa])
);

