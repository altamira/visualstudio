CREATE TABLE [dbo].[Dispositivo_Legal] (
    [cd_dispositivo_legal]    INT          NOT NULL,
    [nm_dispositivo_legal]    VARCHAR (60) NOT NULL,
    [sg_dispositivo_legal]    CHAR (10)    NOT NULL,
    [ds_dispositivo_legal]    TEXT         NOT NULL,
    [cd_imposto]              INT          NOT NULL,
    [cd_usuario]              INT          NOT NULL,
    [dt_usuario]              DATETIME     NOT NULL,
    [dt_validade_dispositivo] DATETIME     NULL,
    [ic_status_dispositivo]   CHAR (1)     NULL,
    CONSTRAINT [PK_Dispositivo_Legal] PRIMARY KEY CLUSTERED ([cd_dispositivo_legal] ASC) WITH (FILLFACTOR = 90)
);

