CREATE TABLE [dbo].[Local_Correspondencia] (
    [cd_local_correspondencia]  INT          NOT NULL,
    [nm_local_correspondencia]  VARCHAR (30) NULL,
    [sg_local_correspondencia]  CHAR (10)    NULL,
    [ic_pad_lo_correspondencia] CHAR (1)     NULL,
    [ic_cad_lo_correspondencia] CHAR (1)     NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Local_Correspondencia] PRIMARY KEY CLUSTERED ([cd_local_correspondencia] ASC) WITH (FILLFACTOR = 90)
);

