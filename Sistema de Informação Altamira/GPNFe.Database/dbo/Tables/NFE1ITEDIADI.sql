CREATE TABLE [dbo].[NFE1ITEDIADI] (
    [NFe0Emp]                      CHAR (2)  NOT NULL,
    [NFe0FatNum]                   INT       NOT NULL,
    [NFe0FatTip]                   CHAR (1)  NOT NULL,
    [NFe0FatCnpjCpfEmi]            CHAR (14) NOT NULL,
    [NFe1_nItem]                   SMALLINT  NOT NULL,
    [NFe2_prod_DI_adi_nAdicao]     SMALLINT  NOT NULL,
    [NFe2_prod_DI_adi_nSeqAdic]    SMALLINT  NOT NULL,
    [NFe2_prod_DI_adi_cFabricante] CHAR (60) NOT NULL,
    [NFe2_prod_DI_adi_vDescDI]     MONEY     NOT NULL,
    PRIMARY KEY CLUSTERED ([NFe0Emp] ASC, [NFe0FatNum] ASC, [NFe0FatTip] ASC, [NFe0FatCnpjCpfEmi] ASC, [NFe1_nItem] ASC, [NFe2_prod_DI_adi_nAdicao] ASC, [NFe2_prod_DI_adi_nSeqAdic] ASC)
);

