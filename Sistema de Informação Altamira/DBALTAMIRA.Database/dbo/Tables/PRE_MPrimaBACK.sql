CREATE TABLE [dbo].[PRE_MPrimaBACK] (
    [prmp_Categoria]        VARCHAR (3)   NOT NULL,
    [prmp_CodTipo]          VARCHAR (3)   NOT NULL,
    [prmp_Especificação]    VARCHAR (5)   NOT NULL,
    [prmp_Dimensão]         VARCHAR (3)   NOT NULL,
    [prmp_Diversos]         VARCHAR (6)   NOT NULL,
    [prmp_Tipo]             VARCHAR (30)  NULL,
    [prmp_Unidade]          VARCHAR (10)  NULL,
    [prmp_UnidadeAquisição] VARCHAR (15)  NULL,
    [prmp_BasicaSec]        REAL          NULL,
    [prmp_PrecoMedio]       MONEY         NULL,
    [prmp_Valor]            MONEY         NULL,
    [prmp_Peso]             FLOAT (53)    NULL,
    [prmp_Descricao]        TEXT          NULL,
    [prmp_Norma]            VARCHAR (10)  NULL,
    [prmp_Prioridade]       VARCHAR (2)   NULL,
    [prmp_DataCadastro]     SMALLDATETIME NULL,
    [prmp_DataAlteração]    SMALLDATETIME NULL,
    [prmp_Lock]             VARBINARY (8) NULL
);

