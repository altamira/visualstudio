CREATE TABLE [dbo].[LOGADMIN] (
    [NM_ESTACAO]       CHAR (10)    NOT NULL,
    [DT_USUARIO]       DATETIME     NOT NULL,
    [CD_USUARIO]       INT          NULL,
    [NM_TABELA]        VARCHAR (60) NULL,
    [NM_CAMPO]         VARCHAR (60) NULL,
    [IC_TIPO_OPERACAO] CHAR (1)     NULL,
    [DS_SQLCOMMAND]    TEXT         NULL
);

