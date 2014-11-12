CREATE TABLE [dbo].[Registro_OS] (
    [cd_os]                   INT          NOT NULL,
    [dt_os]                   DATETIME     NOT NULL,
    [cd_cliente]              INT          NULL,
    [nm_solicitante]          VARCHAR (50) NULL,
    [cd_departamento_cliente] INT          NULL,
    [nm_atividade]            VARCHAR (50) NULL,
    [cd_analista]             INT          NULL,
    [qt_total_horas]          FLOAT (53)   NOT NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Registro_OS] PRIMARY KEY CLUSTERED ([cd_os] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Registro_OS_Analista] FOREIGN KEY ([cd_analista]) REFERENCES [dbo].[Analista] ([cd_analista]),
    CONSTRAINT [FK_Registro_OS_Cliente] FOREIGN KEY ([cd_cliente]) REFERENCES [dbo].[Cliente] ([cd_cliente])
);

