CREATE TABLE [dbo].[Procedimento_Filtro] (
    [cd_procedimento]           INT           NOT NULL,
    [cd_filtro]                 INT           NOT NULL,
    [nm_filtro]                 VARCHAR (50)  NULL,
    [ic_tipo_filtro]            CHAR (1)      NULL,
    [nm_campo]                  VARCHAR (50)  NULL,
    [nm_campo_descricao_lookup] VARCHAR (50)  NULL,
    [nm_chave_lookup]           VARCHAR (50)  NULL,
    [nm_tabela_lookup]          VARCHAR (50)  NULL,
    [nm_instrucao_sql]          TEXT          NULL,
    [ic_tipo_operador]          CHAR (1)      NULL,
    [ic_filtro_obrigatorio]     CHAR (1)      NULL,
    [cd_usuario]                INT           NULL,
    [dt_usuario]                DATETIME      NULL,
    [nm_campo_chave_lookup]     VARCHAR (50)  NULL,
    [cd_natureza_atributo]      INT           NULL,
    [nm_parametro]              VARCHAR (100) NULL,
    CONSTRAINT [PK_Procedimento_Filtro] PRIMARY KEY CLUSTERED ([cd_procedimento] ASC, [cd_filtro] ASC) WITH (FILLFACTOR = 90)
);

