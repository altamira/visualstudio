CREATE TABLE [dbo].[Sintegra_String] (
    [cd_sintegra_string]      INT          NOT NULL,
    [nm_sintegra_string]      VARCHAR (40) NULL,
    [ic_tipo_string]          CHAR (1)     NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [nm_obs_sintegra_string]  VARCHAR (40) NULL,
    [nm_html_sintegra_string] VARCHAR (40) NULL,
    CONSTRAINT [PK_Sintegra_String] PRIMARY KEY CLUSTERED ([cd_sintegra_string] ASC) WITH (FILLFACTOR = 90)
);

