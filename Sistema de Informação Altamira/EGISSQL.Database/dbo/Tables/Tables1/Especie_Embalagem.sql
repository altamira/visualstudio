CREATE TABLE [dbo].[Especie_Embalagem] (
    [cd_especie_embalagem]    INT          NOT NULL,
    [nm_especie_embalagem]    VARCHAR (30) NULL,
    [sg_especie_embalagem]    CHAR (10)    NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [qt_especie_embalagem]    FLOAT (53)   NULL,
    [ic_pad_nf_esp_embalagem] CHAR (1)     NULL,
    CONSTRAINT [PK_Especie_Embalagem] PRIMARY KEY CLUSTERED ([cd_especie_embalagem] ASC) WITH (FILLFACTOR = 90)
);

