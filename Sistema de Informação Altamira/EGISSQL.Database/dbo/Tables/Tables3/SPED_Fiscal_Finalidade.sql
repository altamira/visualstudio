CREATE TABLE [dbo].[SPED_Fiscal_Finalidade] (
    [cd_finalidade]  INT          NOT NULL,
    [nm_finalidade]  VARCHAR (40) NULL,
    [cd_sped_fiscal] VARCHAR (15) NULL,
    [cd_usuario]     INT          NULL,
    [dt_usuario]     DATETIME     NULL,
    CONSTRAINT [PK_SPED_Fiscal_Finalidade] PRIMARY KEY CLUSTERED ([cd_finalidade] ASC) WITH (FILLFACTOR = 90)
);

