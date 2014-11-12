CREATE TABLE [dbo].[Tipo_Avaliacao_Funcionario] (
    [cd_tipo_aval_funcionario]  INT          NOT NULL,
    [nm_tipo_aval_funcionario]  VARCHAR (40) NULL,
    [sg_tipo_aval_funcionario]  CHAR (10)    NULL,
    [qt_ponto_aval_funcionario] FLOAT (53)   NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Avaliacao_Funcionario] PRIMARY KEY CLUSTERED ([cd_tipo_aval_funcionario] ASC) WITH (FILLFACTOR = 90)
);

