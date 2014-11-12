CREATE TABLE [dbo].[Modulo_Consultor] (
    [cd_modulo]                INT          NOT NULL,
    [cd_consultor]             INT          NOT NULL,
    [ic_tipo_modulo_consultor] CHAR (1)     NULL,
    [ds_modulo_consultor]      TEXT         NULL,
    [nm_obs_modulo_consultor]  VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Modulo_Consultor] PRIMARY KEY CLUSTERED ([cd_modulo] ASC, [cd_consultor] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Modulo_Consultor_Consultor_Implantacao] FOREIGN KEY ([cd_consultor]) REFERENCES [dbo].[Consultor_Implantacao] ([cd_consultor])
);

