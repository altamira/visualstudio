CREATE TABLE [dbo].[Hotel_Diaria] (
    [cd_hotel]            INT          NOT NULL,
    [dt_inicial_hotel]    DATETIME     NOT NULL,
    [dt_final_hotel]      DATETIME     NOT NULL,
    [cd_tipo_diaria]      INT          NOT NULL,
    [vl_diaria_hotel]     FLOAT (53)   NULL,
    [cd_moeda]            INT          NULL,
    [vl_taxa_servico]     FLOAT (53)   NULL,
    [nm_obs_hotel_diaria] VARCHAR (40) NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Hotel_Diaria] PRIMARY KEY CLUSTERED ([cd_hotel] ASC, [dt_inicial_hotel] ASC, [dt_final_hotel] ASC, [cd_tipo_diaria] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Hotel_Diaria_Moeda] FOREIGN KEY ([cd_moeda]) REFERENCES [dbo].[Moeda] ([cd_moeda])
);

