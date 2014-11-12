CREATE TABLE [dbo].[Nota_Saida_Cond_Pagto] (
    [cd_nota_saida]             INT        NOT NULL,
    [cd_num_formulario_nota]    INT        NULL,
    [cd_item_nota_s_condicao]   INT        NOT NULL,
    [qt_dia_parcela_nota_saida] INT        NULL,
    [pc_parcela_nota_saida]     FLOAT (53) NULL,
    [cd_parcela_nota_saida]     CHAR (2)   NULL,
    [vl_parcela]                FLOAT (53) NULL,
    [cd_usuario]                INT        NULL,
    [dt_usuario]                DATETIME   NULL
);

