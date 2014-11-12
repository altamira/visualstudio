CREATE TABLE [dbo].[Email_item] (
    [cd_email_item]       INT          NOT NULL,
    [nm_email_item]       VARCHAR (50) NOT NULL,
    [ic_ativo_email_item] CHAR (1)     NULL,
    [ds_email_item]       TEXT         NULL,
    [nm_obs_email_item]   VARCHAR (40) NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Email_item] PRIMARY KEY CLUSTERED ([cd_email_item] ASC) WITH (FILLFACTOR = 90)
);

