CREATE TABLE [dbo].[NtDuplicata] (
    [cd_contador]             INT          IDENTITY (1, 1) NOT NULL,
    [cd_nota_saida]           INT          NULL,
    [dt_nota_saida]           VARCHAR (10) NULL,
    [cd_documento_receber]    INT          NULL,
    [dt_vencimento_documento] VARCHAR (10) NULL
);

