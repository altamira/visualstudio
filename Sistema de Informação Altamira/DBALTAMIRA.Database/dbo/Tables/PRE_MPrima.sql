CREATE TABLE [dbo].[PRE_MPrima] (
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
    [prmp_Completo]         VARCHAR (20)  NULL,
    [prmp_Lock]             VARBINARY (8) NULL,
    CONSTRAINT [PK_PRE_MPrima] PRIMARY KEY NONCLUSTERED ([prmp_Categoria] ASC, [prmp_CodTipo] ASC, [prmp_Especificação] ASC, [prmp_Dimensão] ASC, [prmp_Diversos] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IX_PRE_MPrima]
    ON [dbo].[PRE_MPrima]([prmp_Completo] ASC) WITH (FILLFACTOR = 90);

