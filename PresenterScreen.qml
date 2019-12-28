
import QtQuick 2.0
import presenter 1.0
import QtMultimedia 5.8

Rectangle {
	id: "container"
	anchors.fill: parent
	color: "black"

	Item {
		anchors.fill: parent

		transform: [
			Translate {
				x: -controller.rectPos.x
				y: -controller.rectPos.y
			},
			Scale {
				xScale: container.width / controller.rectWidth
				yScale: container.width / controller.rectWidth
			}
		]

		// The image itself
		Item {
			id: imageItem
			anchors.fill: parent
			transform: [
				Scale {
					xScale: 1.0 / Math.max(mediaItem.mediaWidth, mediaItem.mediaHeight)
					yScale: 1.0 / Math.max(mediaItem.mediaWidth, mediaItem.mediaHeight)
				}
			]

			MediaItem {
				id: mediaItem
				width: mediaWidth
				height: mediaHeight
			}
		}

		Item {
			id: cellsRect

			x: controller.cellsRect.x
			y: controller.cellsRect.y
			width: controller.cellsRect.width
			height: controller.cellsRect.height

			property int cellsX: controller.cellsX
			property int cellsY: controller.cellsY
			property real cellWidth: width / cellsX
			property real cellHeight: height / cellsY
			property real cellBorder: 1.0 / (container.width / controller.rectWidth)

			Repeater
			{
				id: cellsView
				model: controller.cellModel

				delegate: Rectangle {
					id: delegate
					width: cellsRect.cellWidth + cellsRect.cellBorder
					height: cellsRect.cellHeight + cellsRect.cellBorder
					x: (index % cellsRect.cellsX) * cellsRect.cellWidth - cellsRect.cellBorder/2
					y: Math.floor(index / cellsRect.cellsX) * cellsRect.cellHeight - cellsRect.cellBorder/2

					color: "black";
					opacity: cellVisible ? 0.0 : 1.0
					antialiasing: true

					Behavior on opacity { NumberAnimation { duration: 1000 } }
				}
			}
		}

		// Cover everything else
		Rectangle {
			color: "black"
			anchors.left: parent.left
			anchors.right: cellsRect.left
			anchors.top: parent.top
			anchors.bottom: parent.bottom
		}
		Rectangle {
			color: "black"
			anchors.left: cellsRect.right
			anchors.right: parent.right
			anchors.top: parent.top
			anchors.bottom: parent.bottom
		}
		Rectangle {
			color: "black"
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.top: parent.top
			anchors.bottom: cellsRect.top
		}
		Rectangle {
			color: "black"
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.top: cellsRect.bottom
			anchors.bottom: parent.bottom
		}
	}

	Binding {
		target: controller
		property: "presenterResolution"
		value: container.width / controller.rectWidth
	}
}
