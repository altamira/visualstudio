CREATE TABLE [dbo].[Opcao_Ferias] (
    [cd_opcao]                  INT          NOT NULL,
    [nm_opcao]                  VARCHAR (60) NULL,
    [qt_dia_opcao_ferias]       INT          NULL,
    [qt_dia_pecunia_ferias]     INT          NULL,
    [qt_dia_programacao_ferias] INT          NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Opcao_Ferias] PRIMARY KEY CLUSTERED ([cd_opcao] ASC)
);

