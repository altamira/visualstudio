CREATE TABLE [dbo].[Filtro_Arquivo_Magnetico] (
    [cd_documento_magnetico]    INT          NOT NULL,
    [cd_filtro]                 INT          NOT NULL,
    [nm_filtro]                 VARCHAR (40) NULL,
    [ic_tipo_filtro]            CHAR (1)     NULL,
    [nm_campo]                  VARCHAR (40) NULL,
    [nm_campo_descricao_lookup] VARCHAR (40) NULL,
    [nm_campo_chave_lookup]     VARCHAR (40) NULL,
    [nm_tabela_lookup]          VARCHAR (40) NULL,
    [nm_instrucao_sql]          TEXT         NULL,
    [ic_tipo_operador]          CHAR (2)     NULL,
    [ic_filtro_obrigatorio]     CHAR (1)     NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [cd_sessao_documento]       INT          NULL,
    [nm_tabela]                 VARCHAR (40) NULL,
    CONSTRAINT [PK_Filtro_Arquivo_Magnetico] PRIMARY KEY CLUSTERED ([cd_documento_magnetico] ASC, [cd_filtro] ASC) WITH (FILLFACTOR = 90)
);

