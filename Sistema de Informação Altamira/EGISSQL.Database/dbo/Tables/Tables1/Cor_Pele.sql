CREATE TABLE [dbo].[Cor_Pele] (
    [cd_cor_pele]       INT          NOT NULL,
    [nm_cor_pele]       VARCHAR (15) NULL,
    [sg_cor_pele]       CHAR (10)    NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    [cd_caged_cor_pele] INT          NULL,
    CONSTRAINT [PK_Cor_Pele] PRIMARY KEY CLUSTERED ([cd_cor_pele] ASC) WITH (FILLFACTOR = 90)
);

