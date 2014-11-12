CREATE TABLE [dbo].[Indice_Reajuste] (
    [cd_indice_reajuste]        INT          NOT NULL,
    [nm_indice_reajuste]        VARCHAR (40) NOT NULL,
    [sg_indice_reajuste]        CHAR (10)    NULL,
    [ic_padrao_indice_reajuste] CHAR (1)     NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Indice_Reajuste] PRIMARY KEY CLUSTERED ([cd_indice_reajuste] ASC) WITH (FILLFACTOR = 90)
);

