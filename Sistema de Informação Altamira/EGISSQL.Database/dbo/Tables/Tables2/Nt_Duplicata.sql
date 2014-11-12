CREATE TABLE [dbo].[Nt_Duplicata] (
    [cd_contador]             INT          NOT NULL,
    [cd_nota_saida]           INT          NULL,
    [dt_nota_saida]           VARCHAR (10) NULL,
    [cd_documento_receber]    INT          NULL,
    [dt_vencimento_documento] VARCHAR (10) NULL,
    CONSTRAINT [PK_Nt_Duplicata] PRIMARY KEY CLUSTERED ([cd_contador] ASC) WITH (FILLFACTOR = 90)
);

