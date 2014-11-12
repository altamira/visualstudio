CREATE TABLE [dbo].[Iso_Processo] (
    [cd_iso_processo]           INT           NOT NULL,
    [dt_iso_processo]           DATETIME      NOT NULL,
    [nm_iso_processo]           VARCHAR (60)  NOT NULL,
    [ds_iso_processo]           TEXT          NULL,
    [cd_mascara_iso_processo]   VARCHAR (20)  NULL,
    [cd_empresa]                INT           NULL,
    [cd_departamento]           INT           NULL,
    [cd_usuario_responsavel]    INT           NULL,
    [cd_menu]                   INT           NULL,
    [cd_usuario]                INT           NULL,
    [dt_usuario]                DATETIME      NULL,
    [nm_obs_iso_processo]       VARCHAR (40)  NULL,
    [nm_documento_iso_processo] VARCHAR (100) NULL,
    [ic_ativo_iso_processo]     CHAR (1)      NULL,
    CONSTRAINT [PK_Iso_Processo] PRIMARY KEY CLUSTERED ([cd_iso_processo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Iso_Processo_Departamento] FOREIGN KEY ([cd_departamento]) REFERENCES [dbo].[Departamento] ([cd_departamento]),
    CONSTRAINT [FK_Iso_Processo_Empresa] FOREIGN KEY ([cd_empresa]) REFERENCES [dbo].[Empresa] ([cd_empresa])
);

