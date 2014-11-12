CREATE TABLE [dbo].[Sedex_Nota_Saida] (
    [cd_sedex_nota_saida]            INT        NOT NULL,
    [dt_sedex_nota_saida]            DATETIME   NULL,
    [qt_sedex_nota_saida]            FLOAT (53) NULL,
    [vl_total_sedex_nota_saida]      FLOAT (53) NULL,
    [ic_etiq_sedex_nota_saida]       CHAR (1)   NULL,
    [ic_lista_sedex_nota_saida]      CHAR (1)   NULL,
    [qt_peso_bruto_sedex_nota_saida] FLOAT (53) NULL,
    [qt_peso_real_sedex_nota_saida]  FLOAT (53) NULL,
    [cd_usuario]                     INT        NULL,
    [dt_usuario]                     DATETIME   NULL,
    [qt_nota_sedex_nota_saida]       FLOAT (53) NULL,
    [qt_pesobru_sedex_not_said]      FLOAT (53) NULL,
    [qt_peso_sedex_nota_sedex]       FLOAT (53) NULL,
    CONSTRAINT [PK_Sedex_Nota_Saida] PRIMARY KEY CLUSTERED ([cd_sedex_nota_saida] ASC) WITH (FILLFACTOR = 90)
);

