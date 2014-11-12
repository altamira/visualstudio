CREATE TABLE [dbo].[Tipo_Termo_Livro_Fiscal] (
    [cd_tipo_termo_livr_fiscal] INT          NOT NULL,
    [nm_tipo_termo_livr_fiscal] VARCHAR (50) NOT NULL,
    [sg_tipo_termo_livr_fiscal] VARCHAR (10) NULL,
    [ic_tipo_termo_livr_fiscal] CHAR (1)     NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [ic_layout_termo_livro]     CHAR (1)     NULL,
    CONSTRAINT [PK_Tipo_Termo_Livro_Fiscal] PRIMARY KEY CLUSTERED ([cd_tipo_termo_livr_fiscal] ASC) WITH (FILLFACTOR = 90)
);

