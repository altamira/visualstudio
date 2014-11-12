CREATE TABLE [dbo].[Local_Deslocamento] (
    [cd_local_deslocamento]     INT          NOT NULL,
    [nm_local_deslocamento]     VARCHAR (40) NULL,
    [sg_local_deslocamento]     CHAR (10)    NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [ic_pad_saida_local]        CHAR (1)     NULL,
    [ic_pad_chegada_local]      CHAR (1)     NULL,
    [qt_km_local_deslocamento]  FLOAT (53)   NULL,
    [qt_dia_local_deslocamento] INT          NULL,
    CONSTRAINT [PK_Local_Deslocamento] PRIMARY KEY CLUSTERED ([cd_local_deslocamento] ASC) WITH (FILLFACTOR = 90)
);

