CREATE TABLE [dbo].[Processo_Iso] (
    [cd_processo_iso]         INT          NOT NULL,
    [dt_processo_iso]         DATETIME     NOT NULL,
    [nm_processo_iso]         VARCHAR (40) NOT NULL,
    [dt_usuario]              DATETIME     NOT NULL,
    [cd_usuario]              INT          NOT NULL,
    [cd_empresa]              INT          NOT NULL,
    [cd_departamento]         INT          NOT NULL,
    [ds_processo_iso]         TEXT         NOT NULL,
    [cd_mascara_processo_iso] INT          NOT NULL,
    CONSTRAINT [PK_Processo_Iso] PRIMARY KEY CLUSTERED ([cd_processo_iso] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Processo_Iso_Departamento] FOREIGN KEY ([cd_departamento]) REFERENCES [dbo].[Departamento] ([cd_departamento]),
    CONSTRAINT [FK_Processo_Iso_Empresa] FOREIGN KEY ([cd_empresa]) REFERENCES [dbo].[Empresa] ([cd_empresa])
);

