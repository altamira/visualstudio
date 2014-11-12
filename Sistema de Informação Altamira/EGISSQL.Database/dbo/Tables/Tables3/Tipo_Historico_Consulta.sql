CREATE TABLE [dbo].[Tipo_Historico_Consulta] (
    [cd_tipo_historico_consulta] INT          NOT NULL,
    [nm_tipo_historico_consulta] VARCHAR (40) NULL,
    [cd_departamento]            INT          NULL,
    [ic_gera_ocorrencia]         CHAR (1)     NULL,
    [ic_gera_custo]              CHAR (1)     NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Historico_Consulta] PRIMARY KEY CLUSTERED ([cd_tipo_historico_consulta] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Tipo_Historico_Consulta_Departamento] FOREIGN KEY ([cd_departamento]) REFERENCES [dbo].[Departamento] ([cd_departamento])
);

