CREATE TABLE [dbo].[DRE_Tipo] (
    [cd_dre_tipo]       INT          NOT NULL,
    [nm_dre_tipo]       VARCHAR (40) NULL,
    [sg_dre_tipo]       CHAR (10)    NULL,
    [ic_pad_dre_tipo]   CHAR (1)     NULL,
    [ic_ativo_dre_tipo] CHAR (1)     NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_DRE_Tipo] PRIMARY KEY CLUSTERED ([cd_dre_tipo] ASC) WITH (FILLFACTOR = 90)
);

