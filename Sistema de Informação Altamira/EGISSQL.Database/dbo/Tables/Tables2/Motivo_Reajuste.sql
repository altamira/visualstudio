CREATE TABLE [dbo].[Motivo_Reajuste] (
    [cd_motivo_reajuste]       INT          NOT NULL,
    [nm_motivo_reajuste]       VARCHAR (40) NOT NULL,
    [sg_motivo_reajuste]       CHAR (10)    NULL,
    [ic_lista_motivo_reajuste] CHAR (1)     NULL,
    [cd_usuario]               INT          NOT NULL,
    [dt_usuario]               DATETIME     NOT NULL,
    [ic_pad_motivo_reajuste]   CHAR (1)     NULL,
    [nm_obs_motivo_reajuste]   VARCHAR (40) NULL,
    CONSTRAINT [PK_Motivo_Reajuste] PRIMARY KEY CLUSTERED ([cd_motivo_reajuste] ASC) WITH (FILLFACTOR = 90)
);

