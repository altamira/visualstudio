CREATE TABLE [dbo].[check_list] (
    [descricao]          NVARCHAR (50)  NULL,
    [grupo]              NVARCHAR (50)  NULL,
    [imagem]             NVARCHAR (50)  NULL,
    [comando_executar]   NVARCHAR (50)  NULL,
    [lista_dados]        NVARCHAR (250) NULL,
    [opcao]              BIT            NOT NULL,
    [ordem]              INT            NULL,
    [Valor_padrao]       NVARCHAR (50)  NULL,
    [tempo_apresentacao] INT            NULL,
    [Variavel_projeto]   NVARCHAR (50)  NULL,
    [permitir_edicao]    BIT            NOT NULL,
    [ativo]              BIT            NOT NULL,
    [tag_atributo]       NVARCHAR (50)  NULL
);

