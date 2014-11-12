CREATE TABLE [dbo].[Local_Bem_Ciap] (
    [cd_local_bem]          INT          NOT NULL,
    [nm_local_bem]          VARCHAR (40) NULL,
    [sg_local_bem]          CHAR (10)    NULL,
    [cd_insc_est_local_bem] VARCHAR (20) NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Local_Bem_Ciap] PRIMARY KEY CLUSTERED ([cd_local_bem] ASC) WITH (FILLFACTOR = 90)
);

