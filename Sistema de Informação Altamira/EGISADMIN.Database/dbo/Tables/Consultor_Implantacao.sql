CREATE TABLE [dbo].[Consultor_Implantacao] (
    [cd_consultor]          INT          NOT NULL,
    [nm_consultor]          VARCHAR (40) NULL,
    [nm_fantasia_consultor] VARCHAR (15) NULL,
    [cd_ddd_consultor]      VARCHAR (4)  NULL,
    [cd_fone_consultor]     VARCHAR (15) NULL,
    [cd_celular_consultor]  VARCHAR (15) NULL,
    [ds_consultor]          TEXT         NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [ic_tipo_consultor]     CHAR (1)     NULL,
    CONSTRAINT [PK_Consultor_Implantacao] PRIMARY KEY CLUSTERED ([cd_consultor] ASC) WITH (FILLFACTOR = 90)
);

