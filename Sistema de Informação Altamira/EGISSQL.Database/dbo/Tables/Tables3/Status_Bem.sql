CREATE TABLE [dbo].[Status_Bem] (
    [cd_status_bem]         INT          NOT NULL,
    [nm_status_bem]         VARCHAR (30) COLLATE SQL_Latin1_General_CP1250_CI_AS NULL,
    [sg_status_bem]         CHAR (10)    COLLATE SQL_Latin1_General_CP1250_CI_AS NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [ic_calculo_status_bem] CHAR (1)     NULL,
    [ic_pad_status_bem]     CHAR (1)     NULL,
    CONSTRAINT [pk_cd_status_bem] PRIMARY KEY CLUSTERED ([cd_status_bem] ASC) WITH (FILLFACTOR = 90)
);

