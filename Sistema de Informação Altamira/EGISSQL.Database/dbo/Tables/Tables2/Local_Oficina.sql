CREATE TABLE [dbo].[Local_Oficina] (
    [cd_local_oficina]  INT          NOT NULL,
    [nm_local_oficina]  VARCHAR (40) NULL,
    [sg_local_oficiona] CHAR (10)    NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_Local_Oficina] PRIMARY KEY CLUSTERED ([cd_local_oficina] ASC) WITH (FILLFACTOR = 90)
);

