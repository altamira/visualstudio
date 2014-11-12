CREATE TABLE [dbo].[Consulta_Historico] (
    [cd_consulta]                INT          NOT NULL,
    [cd_consulta_historico]      INT          NOT NULL,
    [dt_consulta_historico]      DATETIME     NULL,
    [cd_tipo_consulta_historico] INT          NULL,
    [nm_consulta_historico_1]    VARCHAR (40) NULL,
    [nm_consulta_historico_2]    VARCHAR (40) NULL,
    [nm_consulta_historico_3]    VARCHAR (40) NULL,
    [nm_consulta_historico_4]    VARCHAR (40) NULL,
    [cd_departamento]            INT          NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    CONSTRAINT [PK_Consulta_Historico] PRIMARY KEY CLUSTERED ([cd_consulta] ASC, [cd_consulta_historico] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Consulta_Historico_Departamento] FOREIGN KEY ([cd_departamento]) REFERENCES [dbo].[Departamento] ([cd_departamento])
);

