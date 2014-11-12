CREATE TABLE [dbo].[Tipo_Fluxo_Caixa] (
    [cd_tipo_fluxo_caixa] INT           NOT NULL,
    [nm_tipo_fluxo_caixa] VARCHAR (40)  NULL,
    [sg_tipo_fluxo_caixa] CHAR (10)     NULL,
    [cd_usuario]          INT           NULL,
    [dt_usuario]          DATETIME      NULL,
    [nm_documento_fluxo]  VARCHAR (100) NULL,
    [cd_barra_fluxo]      INT           NULL,
    [cd_departamento]     INT           NULL,
    CONSTRAINT [PK_Tipo_Fluxo_Caixa] PRIMARY KEY CLUSTERED ([cd_tipo_fluxo_caixa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Tipo_Fluxo_Caixa_Departamento] FOREIGN KEY ([cd_departamento]) REFERENCES [dbo].[Departamento] ([cd_departamento])
);

