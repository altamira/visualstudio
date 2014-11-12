CREATE TABLE [dbo].[Local_Saida] (
    [cd_local_saida]        INT          NOT NULL,
    [nm_local_saida]        VARCHAR (40) NULL,
    [sg_local_saida]        CHAR (10)    NULL,
    [cd_usuario]            INT          NULL,
    [dt_atualizacao]        DATETIME     NULL,
    [ic_padrao_local_saida] CHAR (1)     NULL,
    CONSTRAINT [PK_Local_Saida] PRIMARY KEY CLUSTERED ([cd_local_saida] ASC) WITH (FILLFACTOR = 90)
);

