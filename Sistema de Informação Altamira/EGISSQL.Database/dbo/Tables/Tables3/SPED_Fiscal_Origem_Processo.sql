CREATE TABLE [dbo].[SPED_Fiscal_Origem_Processo] (
    [cd_origem_processo] INT          NOT NULL,
    [nm_origem_processo] VARCHAR (40) NULL,
    [cd_sped_fiscal]     VARCHAR (15) NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_SPED_Fiscal_Origem_Processo] PRIMARY KEY CLUSTERED ([cd_origem_processo] ASC) WITH (FILLFACTOR = 90)
);

