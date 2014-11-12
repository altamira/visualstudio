CREATE TABLE [dbo].[Origem_Processo] (
    [cd_origem_processo]     INT          NOT NULL,
    [nm_origem_processo]     VARCHAR (30) NULL,
    [sg_origem_processo]     CHAR (10)    NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [ic_origem_processo]     CHAR (1)     NULL,
    [ic_pad_origem_processo] CHAR (1)     NULL,
    CONSTRAINT [PK_Origem_Processo] PRIMARY KEY CLUSTERED ([cd_origem_processo] ASC) WITH (FILLFACTOR = 90)
);

