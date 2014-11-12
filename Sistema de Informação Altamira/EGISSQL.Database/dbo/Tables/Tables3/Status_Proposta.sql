CREATE TABLE [dbo].[Status_Proposta] (
    [cd_status_proposta] INT          NOT NULL,
    [nm_status_proposta] VARCHAR (30) COLLATE SQL_Latin1_General_CP1250_CI_AS NOT NULL,
    [sg_status_proposta] CHAR (10)    COLLATE SQL_Latin1_General_CP1250_CI_AS NOT NULL,
    [ic_tipo_proposta]   CHAR (1)     COLLATE SQL_Latin1_General_CP1250_CI_AS NOT NULL,
    [cd_usuario]         INT          NOT NULL,
    [dt_usuario]         DATETIME     NOT NULL,
    CONSTRAINT [PK_Status_Proposta] PRIMARY KEY CLUSTERED ([cd_status_proposta] ASC) WITH (FILLFACTOR = 90)
);

