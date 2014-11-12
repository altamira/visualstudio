CREATE TABLE [dbo].[SPED_Fiscal_Genero] (
    [cd_genero]  INT           NOT NULL,
    [nm_genero]  VARCHAR (100) NULL,
    [sg_genero]  CHAR (10)     NULL,
    [ds_genero]  TEXT          NULL,
    [cd_usuario] INT           NULL,
    [dt_usuario] DATETIME      NULL,
    CONSTRAINT [PK_SPED_Fiscal_Genero] PRIMARY KEY CLUSTERED ([cd_genero] ASC) WITH (FILLFACTOR = 90)
);

