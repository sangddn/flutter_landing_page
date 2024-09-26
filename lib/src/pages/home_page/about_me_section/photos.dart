part of '../home_page.dart';

class _Photos extends StatelessWidget {
  const _Photos();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 420.0),
      child: MediaScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: math.max(16.0, (width - 600.0) / 2),
        ),
        cornerRadius: 16.0,
        pattern: const StraightPattern(),
        thumbnails: _photos.map((t) => t.$1).toIList(),
        getHeroTag: (url) => url,
        imageBuilder: (
          absoluteIndex,
          crossAxisIndex,
          numChildrenInCrossAxis,
          thumbnail,
          sizedChild,
        ) {
          final colors = _photos[absoluteIndex].$2;
          return Container(
            decoration: ShapeDecoration(
              color: theme.resolveColor(PColors.white, PColors.dark2),
              shape: const PContinuousRectangleBorder(cornerRadius: 24.0),
              shadows: colors
                  .indexedExpand(
                    (index, color) => PDecors.focusedShadows(
                      elevation: colors.length - index.toDouble(),
                      baseColor: color.adaptForContext(context),
                    ),
                  )
                  .toList(),
            ),
            padding: k8APadding,
            width: 300.0 + 16.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sizedChild,
                const Gap(8.0),
                Text(
                  thumbnail.title ?? 'Title',
                  style: theme.textTheme.titleMedium,
                ).pad8H(),
                const Gap(4.0),
                Text(
                  thumbnail.description ?? 'Description',
                  style: theme.textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ).pad8H(),
                const Gap(8.0),
              ],
            ),
          );
        },
      ),
    );
  }
}

const _photos = <(Thumbnail, List<Color>)>[
  (
    Thumbnail(
      sourceUrl:
          'https://imagedelivery.net/2Gn8B8Jy4jQZZd-Mdw0X0A/e5d4af4f-5ee7-4b98-43fa-312cb430a000/publicFullHD',
      thumbnailUrl:
          'https://imagedelivery.net/2Gn8B8Jy4jQZZd-Mdw0X0A/e5d4af4f-5ee7-4b98-43fa-312cb430a000/publicSquareThumbnail',
      thumbnailHeight: 800,
      thumbnailWidth: 800,
      mediaType: MediaType.image,
      title: 'Where I’m from',
      description: 'I grew up in the plains of Nam Dinh, Vietnam.',
    ),
    [Color(0xff2F8AE9), PColors.freshGreen]
  ),
  (
    Thumbnail(
      sourceUrl:
          'https://imagedelivery.net/2Gn8B8Jy4jQZZd-Mdw0X0A/b077056b-5413-46e7-51a2-ebfe57c28b00/publicFullHD',
      thumbnailUrl:
          'https://imagedelivery.net/2Gn8B8Jy4jQZZd-Mdw0X0A/b077056b-5413-46e7-51a2-ebfe57c28b00/publicSquareThumbnail',
      thumbnailHeight: 800,
      thumbnailWidth: 800,
      mediaType: MediaType.image,
      title: 'College',
      description:
          'And studied Mathematics at Georgetown University, Washington D.C.',
    ),
    [Color(0xffCEB85B)]
  ),
  (
    Thumbnail(
      sourceUrl:
          'https://imagedelivery.net/2Gn8B8Jy4jQZZd-Mdw0X0A/6c4597d3-dda2-47a6-a950-9f6879264d00/publicFullHD',
      thumbnailUrl:
          'https://imagedelivery.net/2Gn8B8Jy4jQZZd-Mdw0X0A/6c4597d3-dda2-47a6-a950-9f6879264d00/publicSquareThumbnail',
      width: 3024,
      height: 3024,
      thumbnailHeight: 800,
      thumbnailWidth: 800,
      mediaType: MediaType.image,
      title: 'Explore the States',
      description:
          'In the US, I got to try things I never even imagined. Including those that seem a cultural banality like water rafting.',
    ),
    [Color(0xffC6DDE9)]
  ),
  (
    Thumbnail(
      sourceUrl:
          'https://imagedelivery.net/2Gn8B8Jy4jQZZd-Mdw0X0A/ff03e89f-1dba-4085-a080-205bd6a63400/publicFullHD',
      thumbnailUrl:
          'https://imagedelivery.net/2Gn8B8Jy4jQZZd-Mdw0X0A/ff03e89f-1dba-4085-a080-205bd6a63400/publicSquareThumbnail',
      thumbnailHeight: 800,
      thumbnailWidth: 800,
      mediaType: MediaType.image,
      title: 'Times Square',
      description: 'A tourist’s obligatory photo in Times Square.',
    ),
    [Color(0xff9E867A)]
  ),
  (
    Thumbnail(
      sourceUrl:
          'https://imagedelivery.net/2Gn8B8Jy4jQZZd-Mdw0X0A/b3c77c95-15f5-4902-5721-d65170bf8d00/publicFullHD',
      thumbnailUrl:
          'https://imagedelivery.net/2Gn8B8Jy4jQZZd-Mdw0X0A/b3c77c95-15f5-4902-5721-d65170bf8d00/publicSquareThumbnail',
      thumbnailHeight: 800,
      thumbnailWidth: 800,
      mediaType: MediaType.image,
      title: 'Puerto Rico',
      description: 'Puerto Rico is one of my favorite places on earth.',
    ),
    [Color(0xff689A99)]
  ),
  (
    Thumbnail(
      sourceUrl:
          'https://imagedelivery.net/2Gn8B8Jy4jQZZd-Mdw0X0A/64ac6bf5-11a6-4fed-7789-3d17d9eb2f00/publicFullHD',
      thumbnailUrl:
          'https://imagedelivery.net/2Gn8B8Jy4jQZZd-Mdw0X0A/64ac6bf5-11a6-4fed-7789-3d17d9eb2f00/publicSquareThumbnail',
      thumbnailHeight: 800,
      thumbnailWidth: 800,
      mediaType: MediaType.image,
      title: 'University College Dublin',
      description: 'I studied abroad in Ireland for a semester. I loved it.',
    ),
    [Color(0xff89974F), Colors.blue]
  ),
  (
    Thumbnail(
      sourceUrl:
          'https://imagedelivery.net/2Gn8B8Jy4jQZZd-Mdw0X0A/5bc10f71-ae1b-44ef-dfc0-13ffa2516a00/publicFullHD',
      thumbnailUrl:
          'https://imagedelivery.net/2Gn8B8Jy4jQZZd-Mdw0X0A/5bc10f71-ae1b-44ef-dfc0-13ffa2516a00/publicSquareThumbnail',
      thumbnailHeight: 800,
      thumbnailWidth: 800,
      mediaType: MediaType.image,
      title: 'Milan',
      description:
          'Milan is my favorite European city (so far). I love the architecture, the trams, and the animated calmness.',
    ),
    [Color(0xffADA69B)]
  ),
  (
    Thumbnail(
      sourceUrl:
          'https://imagedelivery.net/2Gn8B8Jy4jQZZd-Mdw0X0A/8d865b18-4f1a-460e-0a80-81a5f4d0b700/publicFullHD',
      thumbnailUrl:
          'https://imagedelivery.net/2Gn8B8Jy4jQZZd-Mdw0X0A/8d865b18-4f1a-460e-0a80-81a5f4d0b700/publicSquareThumbnail',
      thumbnailHeight: 800,
      thumbnailWidth: 800,
      mediaType: MediaType.image,
      title: 'Graduation',
      description:
          'I graduated in May and am now a full-time software engineer.',
    ),
    [PColors.dark2]
  ),
  (
    Thumbnail(
      sourceUrl:
          'https://imagedelivery.net/2Gn8B8Jy4jQZZd-Mdw0X0A/56c08393-017f-46e0-ad40-4cd69f017c00/publicFullHD',
      thumbnailUrl:
          'https://imagedelivery.net/2Gn8B8Jy4jQZZd-Mdw0X0A/56c08393-017f-46e0-ad40-4cd69f017c00/publicSquareThumbnail',
      thumbnailHeight: 800,
      thumbnailWidth: 800,
      mediaType: MediaType.image,
      title: 'California',
      description:
          'There’s something that screams California about this photo.',
    ),
    [Color(0xffFFBB55)]
  ),
];
